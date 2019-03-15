module Capistrano
  module DSL
    module Symfony

      def symfony_app_path
          release_path.join(fetch(:app_path))
      end

      def symfony_web_path
          release_path.join(fetch(:web_path))
      end

      def symfony_bin_path
        release_path.join(fetch(:bin_path))
      end

      def symfony_var_path
        release_path.join(fetch(:var_path))
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

      def symfony_console_path
          release_path.join(fetch(:symfony_console_path))
      end

      def symfony_vendor_path
        release_path.join('vendor')
      end

      def symfony_console(command, params = '')
        on release_roles(fetch(:symfony_deploy_roles)) do
          execute :php, symfony_console_path, command, params, fetch(:symfony_console_flags)
        end
      end

    end
  end
end
