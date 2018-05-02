# frozen_string_literal: true

class String
  def camelcase
    result = []
    skip_iteration = false

    camelcase_sections.each do |section|
      next if section.empty?
      result << '::' if camelcase_divisor?(section)

      section.split('').each_with_index do |char, index|
        next skip_iteration = false if skip_iteration
        next result << char.upcase if index.zero?

        if apply_camelcase?(char, section[index + 1])
          skip_iteration = true
          next result << section[index + 1].upcase
        end

        result << char
      end
    end

    result.join
  end

  def constantize
    Object.const_get(self)
  end

  def underscore
    result = []

    underscore_sections.each do |section|
      next if section.empty?
      result << '/' if underscore_divisor?(section)

      section.split('').each_with_index do |char, index|
        next result << char unless char.match?(/[a-zA-Z]/)
        next result << char.downcase if index.zero?

        result << '_' if apply_underscore?(char, section[index + 1], section[index - 1])
        result << char.downcase
      end
    end

    result.join
  end

  private

  def apply_camelcase?(char, next_char)
    char == '_' && next_char.match?(/[a-zA-Z]/)
  end

  def apply_underscore?(char, next_char, prev_char)
    char == char.upcase &&
      ((next_char&.match?(/[a-z]/) && prev_char.match?(%r{[^\/|_]})) || prev_char.match?(/[a-z]/))
  end

  def camelcase_divisor?(section)
    scan("/#{section}").any? || scan("::#{section}").any?
  end

  def camelcase_sections
    split(%r{\/|::})
  end

  def underscore_divisor?(section)
    scan("::#{section}").any? || scan("/#{section}").any?
  end

  def underscore_sections
    split(%r{::|\/})
  end
end
