require_relative "../lib/developer"

RSpec.describe Developer do
  describe "#initialize" do
    it "creates a Developer with name, email, and role" do
      dev = Developer.new("Matthew Smith", "matthew.smith@proton.me", "lead")

      expect(dev.name).to eq("Matthew Smith")
      expect(dev.email).to eq("matthew.smith@proton.me")
      expect(dev.role).to eq("lead")
    end

    it "rejects empty name" do
      expect { Developer.new("", "a@b.com", "engineer") }
        .to raise_error(ArgumentError, "Name cannot be empty")
    end

    it "rejects whitespace name" do
      expect { Developer.new("   ", "a@b.com", "engineer") }
        .to raise_error(ArgumentError, "Name cannot be empty")
    end

    it "rejects empty email" do
      expect { Developer.new("Jose", "", "engineer") }
        .to raise_error(ArgumentError, "Email cannot be empty")
    end

    it "rejects invalid email format" do
      expect { Developer.new("Jose", "invalid", "engineer") }
        .to raise_error(ArgumentError, "Invalid email format")
    end

    it "rejects invalid role" do
      expect { Developer.new("Jose", "jose@uofm.edu", "intern") }
        .to raise_error(ArgumentError, "Role must be engineer, lead, or manager")
    end
  end
end