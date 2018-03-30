# Service Object implements the user’s interactions with the application.
# When to use
#   - Business logic is duplicated among controllers or jobs
#   - Business logic is reaching across multiple models
#   - Model or controller gets too fat or too complex
#   - Action is additional to the model, such as notifying
#   - Calling external service
#
# Basic Principles
#   - Serves one specific purpose (Single Responsibility Principle)
#   - A service can act as a wrapper, e.g. calling multiple services. Example: PurchaseService::Create
#
# Conventions
# Strict:
#   - Namespace with domain name
#   - use the facade module to call
#   - Use verb as class name
#   - Have only one public method
#     Remember that it should only serves one specific purpose. If one public method is not sufficient, maybe your service is doing too much?
#   - extend the Service::Base class
module Services
  class Base
    extend ActiveModel::Callbacks
    include Contracts::Core

    C = Contracts

    define_model_callbacks :perform

    class << self
      def after_success_perform(method = nil, &block)
        after_success_perform_callbacks << [method, block]
      end

      def after_success_perform_callbacks
        @after_success_perform_callbacks ||= []
      end
    end

    def call
      run_callbacks :perform do
        perform
      end
    end

    def perform
      raise NotImplementedError
    end

    def initialize(log_info = nil)
      @log_info = log_info
      @log_info.root_service = self if @log_info && !@log_info.root_service
    end

    after_perform do
      if @log_info
        self.class.after_success_perform_callbacks.each do |method, block|
          @log_info.after_perform_queue << [self, Proc.new { self.send(method) }] if method
          @log_info.after_perform_queue << [self, block] if block
          true
        end

        if @log_info.root_service == self
          @log_info.after_perform_queue.each do |service_instance, action|
            service_instance.instance_eval(&action)
          end
          @log_info.after_perform_queue.clear
          @log_info.root_service = nil
        end
      end
    end

  end

  # Base exception occurred on service layer
  class ServiceError < StandardError; end

  # For other errors not logically occurred from service layer
  # Exception which occurred on Core layer also will be wrapped into this
  # that cannot be handled anymore
  # e.g : ActiveRecord::RecordInvalid
  class SystemError < ServiceError; end

  # actor is not eligible to perform the service
  # TODO: remove this when we have proper API authentication

  class InvalidActorError < ServiceError
    def initialize(msg = I18n.t('services.errors.invalid_actor'))
      super
    end
  end

  # some paramater is required to run the service is not provided
  class BadParameterError < ServiceError
    def initialize(msg = I18n.t('services.errors.transaction_payment_failure'))
      super
    end
  end

  # some parameters that were required to run the service is not provided
  class MissingParameterError < ServiceError
    def initialize(field = nil)
      super(I18n.t('services.params.missing', field: field))
    end
  end

  class UnexpectedParameterTypeError < ServiceError
    def initialize(field:, actual:, expected:)
      super(I18n.t('services.params.unexpected', field: field, actual: actual, expected: expected))
    end
  end
end