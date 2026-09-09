class UserImportJob < ApplicationJob
  queue_as :default
  REQUIRED_HEADERS = %w[full_name email].freeze

  def perform(user_import)
    user_import.update!(status: :processing, processed_rows: 0, failed_rows: 0, error_details: [])
    user_import.spreadsheet.open do |file|
      sheet = Roo::Spreadsheet.open(file.path, extension: file_extension(user_import))
      headers = normalized_headers(sheet.row(1))
      validate_headers!(headers)
      user_import.update!(total_rows: [ sheet.last_row - 1, 0 ].max)
      errors = []
      (2..sheet.last_row).each do |row_number|
        import_row(headers.zip(sheet.row(row_number)).to_h)
      rescue ActiveRecord::RecordInvalid => error
        errors << { row: row_number, errors: error.record.errors.full_messages }
      ensure
        user_import.increment!(:processed_rows)
        user_import.update!(failed_rows: errors.size, error_details: errors)
      end
    end
    user_import.update!(status: :completed)
  rescue StandardError => error
    user_import.update!(status: :failed, error_details: [ { error: error.message } ])
    raise
  end

  private
    def normalized_headers(row)
      row.map { |header| header.to_s.strip.downcase.gsub(/[^a-z0-9]+/, "_") }
    end

    def validate_headers!(headers)
      missing = REQUIRED_HEADERS - headers
      raise ArgumentError, "Missing required columns: #{missing.join(', ')}" if missing.any?
    end

    def import_row(attributes)
      User.create!(full_name: attributes["full_name"], email: attributes["email"], role: admin_value?(attributes["role"]) ? :admin : :user, avatar_url: attributes["avatar_url"], password: SecureRandom.base64(18))
    end

    def admin_value?(value)
      value.to_s.strip.downcase.in?(%w[admin true yes 1])
    end

    def file_extension(user_import)
      File.extname(user_import.spreadsheet.filename.to_s).delete_prefix(".").to_sym
    end
end
