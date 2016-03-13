require "shot/version"

module Shot
  class Template
    def initialize(template, scope: Object.new)
      template = File.read(template) if template.end_with?(".shot")
      @template_lines = template.split("\n")
      @scope = scope
    end

    def render(locals = {})
      block = build_lambda(locals)
      parsed_result = @scope.instance_eval(block)
      return parsed_result.call unless block_given?
      parsed_result.call { yield }
    end

    private

    def build_lambda(locals)
      <<-block
        lambda do
          parsed_lines = []
          #{local_variables(locals)}
          #{parse_lines}
          parsed_lines.join("\n")
        end
      block
    end

    def local_variables(locals)
      locals.map do |key, value|
        value = "\"#{value}\"" if value.is_a?(String)
        "#{key} = #{value}"
      end.join("\n")
    end

    def parse_lines
      @template_lines.map do |line|
        if line =~ /^\s*@(.*?)\s*$/
          line.gsub(/^\s*@(.*?)\s*$/, '\1')
        else
          "parsed_lines << \"#{line.gsub(/{{([^\r\n]+)}}/, '#{\1}')}\""
        end
      end.join("\n")
    end
  end
end
