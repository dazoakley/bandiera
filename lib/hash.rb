# frozen_string_literal: true

class Hash
  def symbolize_keys
    each_with_object({}) do |(key, value), result|
      new_key   = case key
                  when String then key.to_sym
                  else key
                  end

      new_value = case value
                  when Hash then value.symbolize_keys
                  else value
                  end

      result[new_key] = new_value
    end
  end
end
