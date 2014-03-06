require "spec_helper"

describe PasswordResetMailer do
  describe "reset_email" do
    let(:patient) { FactoryGirl.create(:patient) }
    let(:mail) { PasswordResetMailer.reset_email(patient, 'Qwerty123') }

    it "renders the headers" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([patient.email])
      mail.from.should eq(["no-reply@mdme.us"])
    end

    it "renders the body" do
      mail.body.encoded.should have_text("Qwerty123")
    end
  end

end
