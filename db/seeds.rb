admin_email = ENV.fetch("SEED_ADMIN_EMAIL", "admin@example.com")
admin_password = ENV.fetch("SEED_ADMIN_PASSWORD", "ChangeMe123!")

admin = User.find_or_initialize_by(email: admin_email)
admin.assign_attributes(full_name: "System Administrator", role: :admin)
admin.password = admin_password if admin.new_record?
admin.save!

if Rails.env.development?
  5.times do |index|
    user = User.find_or_initialize_by(email: "user#{index + 1}@example.com")
    user.assign_attributes(full_name: "Demo User #{index + 1}", role: :user)
    user.password = "ChangeMe123!" if user.new_record?
    user.save!
  end
end

puts "Seeded administrator: #{admin.email}"
