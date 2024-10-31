class SubscriptionsController < ApplicationController
  RESPONSES = %i[success failed insufficient_funds].freeze

  post '/paymentIntents/create' do
    {
      token: '123',
      amount: params[:amount],
      status: RESPONSES.sample
    }.to_json
  end

  post '/schedule' do
    SubscriptionBillingSchedulerWorker.perform_async
  end
end

