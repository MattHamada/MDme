require "spec_helper"

describe SignupMailer do
  describe "signup_confirmation" do
    let (:patient) { FactoryGirl.create(:patient) }
    let(:mail) { SignupMailer.signup_confirmation(patient, 'aCAcdaeAD2') }

    it "renders the headers" do
      mail.subject.should eq("Sign Up Confirmation")
      mail.to.should eq([patient.email])
      mail.from.should eq(["no-reply@mdme.us"])
    end

    it "renders the body" do
      mail.body.encoded.should have_text("aCAcdaeAD2")
    end
  end

end
