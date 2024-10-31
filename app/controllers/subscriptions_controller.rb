class SubscriptionsController < ApplicationController
  RESPONSES = %i[success failed insufficient_funds].freeze

  post '/paymentIntents/create' do
    {
      token: 'xxx-xxx-xxx-xxx',
      amount: 1.0,
      status: RESPONSES.sample
    }.to_json
  end

  post '/schedule' do
    SubscriptionBillingSchedulerWorker.perform_async
  end
end

