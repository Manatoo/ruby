require 'spec_helper'
require 'manatoo'

describe Manatoo::Event do
  before do
    Manatoo.api_key = ENV['API_KEY']
  end

  describe 'task' do

    context 'when creating an event' do
      event_name = 'user_signup'

      it 'creates an event' do
        json = Manatoo::Event.create({
          name: event_name
        })

        expect(json['data']['name']).to eq(event_name)
      end
    end
  end
end
