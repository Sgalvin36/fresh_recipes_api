require 'rails_helper'

RSpec.describe "ErrorMessage" do
    describe '#initialize' do
        it 'initializes with a message and a status code' do
            error_message = ErrorMessage.new('Not Found', 404)
    
            expect(error_message.message).to eq('Not Found')
            expect(error_message.status_code).to eq(404)
        end
    end

    describe 'attributes' do
        it 'returns the correct message' do
            error_message = ErrorMessage.new('Unauthorized Access', 401)
            expect(error_message.message).to eq('Unauthorized Access')
        end

        it 'returns the correct status code' do
            error_message = ErrorMessage.new('Bad Request', 400)
            expect(error_message.status_code).to eq(400)
        end
    end
end  