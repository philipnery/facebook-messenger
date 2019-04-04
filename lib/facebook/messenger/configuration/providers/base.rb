require 'facebook/messenger/configuration/helpers'

module Facebook
  module Messenger
    class Configuration
      module Providers
        # This is the base configuration provider.
        #   User can overwrite this class to customize the environment variables
        #   Be sure to implement all the functions as it raises
        #   NotImplementedError errors.
        class Base
          include Facebook::Messenger::Configuration::Helpers

          # A default caching implentation of generating the app_secret_proof
          # for a given page_id
          def app_secret_proof_for(page_id = nil)
            return unless fetch_app_secret_proof_enabled?

            memo_key = [app_secret_for(page_id), access_token_for(page_id)]
            memoized_app_secret_proofs[memo_key] ||=
              calculate_app_secret_proof(*memo_key)
          end

          def valid_verify_token?(*)
            raise NotImplementedError
          end

          def app_secret_for(*)
            raise NotImplementedError
          end

          def access_token_for(*)
            raise NotImplementedError
          end

          private

          def memoized_app_secret_proofs
            @memoized_app_secret_proofs ||= {}
          end

          def fetch_app_secret_proof_enabled?
            false
          end
        end
      end
    end
  end
end
