require "capistrano/dsl/paths"

module Capistrano
  module DSL
    module Paths

      def symfony_app_path
          release_path.join(fetch(:app_path))
      end

      def symfony_web_path
          release_path.join(fetch(:web_path))
      end

      def symfony_log_path
          release_path.join(fetch(:log_path))
      end

      def symfony_cache_path
          release_path.join(fetch(:cache_path))
      end

      def symfony_config_path
          release_path.join(fetch(:app_config_path))
      end

      def sensio_distribution_bootstrap_path
          bootstrap_path = release_path.join('vendor/sensio/distribution-bundle/')

          unless fetch(:sensio_distribution_version_5)
            bootstrap_path += 'Sensio/Bundle/DistributionBundle/'
          end

          bootstrap_path += 'Resources/bin/build_bootstrap.php'
      end
    end
  end
end
