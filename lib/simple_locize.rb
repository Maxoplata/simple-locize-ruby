require 'net/http'
require 'json'

class SimpleLocize
    def initialize(project_id, environment, private_key = nil)
        @translations = {}
		@project_id = project_id
		@environment = environment
		@private_key = private_key
    end

    def get_all_translations_from_namespace(namespace, language)
        if !@translations.key?(namespace) || !@translations[namespace].key?(language.to_sym)
            fetch_from_locize(namespace, language)
        end

        return @translations[namespace][language.to_sym]
    end

    def translate(namespace, language, key)
        if !@translations.key?(namespace) || !@translations[namespace].key?(language.to_sym)
            fetch_from_locize(namespace, language)
        end

        key_split = key.split('.')

        key_value = if key_split.length == 1
            @translations[namespace][language.to_sym][key] rescue nil
        else
            key_split.reduce(@translations[namespace][language.to_sym] || {}) do |acc, item|
                acc[item] rescue Hash.new
            end
        end

        return key_value.is_a?(String) ? key_value : key
    end

    private

    def fetch_from_locize(namespace, language)
		begin
            uri = URI("https://api.locize.io/#{@private_key.nil? ? '' : 'private/'}#{@project_id}/#{@environment}/#{language}/#{namespace}")

            headers = {}
            headers['Authorization'] = @private_key unless @private_key.nil?

            locize_fetch = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
                request = Net::HTTP::Get.new(uri)

                headers.each { |key, value| request[key] = value }

                http.request(request)
            end

            locize_data = JSON.parse(locize_fetch.body)

            @translations[namespace] = {
                **(@translations[namespace] || {}),
                language.to_sym => locize_data,
            }
		rescue
			# fail
		end
    end
end
