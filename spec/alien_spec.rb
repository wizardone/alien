RSpec.describe Alien do
  it "has a version number" do
    expect(Alien::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
