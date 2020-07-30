RSpec.describe Alien::Connection do

  subject { described_class }

  before do
    #connection = double(Bunny)
    #allow(Bunny).to receive(:new).and_return(connection)
    #allow(connection).to receive(:start)
    #allow(connection).to receive(:create_channel)
    #allow(connection).to receive(:queue)
  end

  it 'initializes a RabbitMQ connection' do
    expect(Bunny).to receive(:new)
    conn = subject.new(service_name: 'Test')

    expect(conn.service_name).to eq('Test')
  end

  it 'starts the network connection' do
    bunny_session = instance_double(Bunny::Session, start: Object.new)
    expect(Bunny).to receive(:new).and_return(bunny_session)
    conn = subject.new(service_name: 'Test')

    expect(conn.start).to be_a(Object)
  end
end
