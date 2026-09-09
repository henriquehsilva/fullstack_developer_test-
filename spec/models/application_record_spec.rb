require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  describe ".abstract_class?" do
    it "is an abstract base class" do
      expect(described_class.abstract_class?).to be(true)
    end
  end
end
