RSpec.describe Alien::Connection do

  subject { described_class }

  it 'initializes a RabbitMQ connection' do
    conn = subject.new(name: 'Test')

    expect(conn.name).to eq('Test')
    expect(conn.ampq).to be_a(Bunny::Session)
  end
end
