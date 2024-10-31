class SubscriptionBillingSchedulerWorker
  include Sidekiq::Worker

  queue_as :cron

  def perform
    subscription_ids = Subscription.includes(:billing_periods)
                                   .active
                                   .where('subscriptions.next_billing_date <= ?', Date.today)
                                   .where.not(billing_periods: { status: :paid, billing_period: Date.today.strftime('%y_%m')})
                                   .pluck(:id)
    subscription_ids.each do
      SubscriptionChargeWorker.new.perform(_1)
    end
  end
end