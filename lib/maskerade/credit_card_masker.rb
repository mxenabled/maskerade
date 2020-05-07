require "luhn_checksum"

# Masks all possible credit card numbers, which may be seperated by dashes or spaces.
# Some options are available to control how the card gets masked.
module Maskerade
  class CreditCardMasker
    attr_reader :replacement_token, :expose_last

    COMPANY_CARD_REGEX = {
      :visa => /\b4\d{3}[ -]?\d{4}[ -]?\d{4}[ -]?(?:\d|\d{4}|\d{7})\b/,
      :amex => /\b3[47]\d{2}[ -]?\d{6}[ -]?\d{5}\b/,
      :diners_club => /\b3(?:0[0-5]|[68]\d)\d[ -]?\d{6}[ -]?(?:\d{4}|\d{9})\b/,
      :mastercard => /\b(?:5[1-5]\d{2}[ -]?\d{2}|6771[ -]?89|222[1-9][ -]?\d{2}|22[3-9]\d[ -]?\d{2}|2[3-6]\d{2}[ -]?\d{2}|27[01]\d[ -]?\d{2}|2720[ -]?\d{2})\d{2}[ -]?\d{4}[ -]?\d{4}\b/,
      :discover => /\b(?:6011|65\d{2}|64[4-9]\d)[ -]?\d{4}[ -]?\d{4}[ -]?(?:\d{4}|\d{7})\b/,
      :union_pay => /\b62\d{2}[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}\b/,
      :jcb => /\b(?:308[89]|309[0-4]|309[6-9]|310[0-2]|311[2-9]|3120|315[8-9]|333[7-9]|334[0-9]|352[89]|35[3-8]\d)[ -]?\d{4}[ -]?\d{4}[ -]?(?:\d{4}|\d{7})\b/,
      :switch_short_iin => /\b(?:4903|4905|4911|4936|6333|6759)[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}(?:\d{2,3})?\b/,
      :switch_long_iin => /\b(?:5641[ -]?82|6331[ -]?10)\d{2}[ -]?\d{4}[ -]?\d{4}(?:\d{2,3})?\b/,
      :solo => /\b(?:6334|6767)[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}(?:\d{2,3})?\b/,
      :dankort => /\b5019[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}\b/,
      :maestro => /\b(?:5[06-8]|6\d)\d{2}[ -]?\d{4}[ -]?\d{4}[ -]?\d{0,7}\b/,
      :forbrugsforeningen => /\b6007[ -]?22\d{2}[ -]?\d{4}[ -]?\d{4}\b/,
      :laser => /\b(?:6304|6706|6709|6771(?!89))[ -]?\d{4}[ -]?\d{4}[ -]?(?:\d{4}|\d{6,7})?\b/
    }

    ALL_CARDS_REGEX = ::Regexp.union(COMPANY_CARD_REGEX.values)
    DIGIT_REGEX = /[[:digit:]]/

    # Options:
    #   replacement_text: The entire card number gets replaced with this text; if set, the other two options are ignored.
    #   replacement_token: The character used to replace digits of the credit number.  Defaults to "X".
    #   expose_last: The number of trailing digits of the credit card number to leave intact.  Defaults to 0.
    def initialize(replacement_text: nil, replacement_token: "X", expose_last: 0)
      @replacement_text = replacement_text
      @replacement_token = replacement_token
      @expose_last = expose_last
    end

    def mask(value)
      value&.gsub(ALL_CARDS_REGEX) do |match|
        mask_one(match)
      end
    end

  private

    def mask_one(value)
      digits = value.tr("^0-9", "")
      return value unless ::LuhnChecksum.valid?(digits)

      return @replacement_text if @replacement_text

      value.gsub(DIGIT_REGEX).with_index do |number, index|
        if index < digits.size - expose_last
          replacement_token
        else
          number
        end
      end
    end
  end
end
