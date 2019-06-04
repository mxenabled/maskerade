# frozen_string_literal: true

require "spec_helper"

# Includes TEST CC numbers from PayPal (link broken; change en_US to en_AU)
# https://www.paypalobjects.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm

::RSpec.describe ::Maskerade::CreditCardMasker do
  describe "#mask" do
    context "when value is nil" do
      it { expect(subject.mask(nil)).to be nil }
    end

    context "when value does not contain a credit card number" do
      [
        "555555-555555-5555",
        "6449 000000 000000",
        "    1-800-555-5555    ",
        "1313131313131",
        "14141414141414",
        "starbucks store #555 1-800-555-5555",
        "business XXXX XXXX XXXX 1234 1234567890123456",
        "4111111111111112", # fails luhn test
        "4 1 3-11 93 3-1-2",
        "4        2      2",
        "677189---------3",
        "30888778502353" # wrong length; should be 16 not 14
      ].each do |value|
        it { expect(subject.mask(value)).to eq(value) }
      end
    end

    context "when value contains an AMEX credit card number" do
      {
        "378282246310005"                                => "XXXXXXXXXXXXXXX",
        "371449635398431"                                => "XXXXXXXXXXXXXXX",
        "377154756108213"                                => "XXXXXXXXXXXXXXX",
        "378734493671000"                                => "XXXXXXXXXXXXXXX",
        "3771-547561-08213"                              => "XXXX-XXXXXX-XXXXX",
        "3771 547561-08213"                              => "XXXX XXXXXX-XXXXX",
        "3771 547561 08213"                              => "XXXX XXXXXX XXXXX",
        "3771 54756108213"                               => "XXXX XXXXXXXXXXX",
        "Starbucks Store #555 3771 547561 08213"         => "Starbucks Store #555 XXXX XXXXXX XXXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Diners Club credit card number" do
      {
        "30569309025904"                                  => "XXXXXXXXXXXXXX",
        "38520000023237"                                  => "XXXXXXXXXXXXXX",
        "5434731844539705"                                => "XXXXXXXXXXXXXXXX",
        "5434 7318 4453 9705"                             => "XXXX XXXX XXXX XXXX",
        "5434-7318 4453-9705"                             => "XXXX-XXXX XXXX-XXXX",
        "5434 7318-4453 9705"                             => "XXXX XXXX-XXXX XXXX",
        "Starbucks Store #555 5434 7318 4453 9705"        => "Starbucks Store #555 XXXX XXXX XXXX XXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Discover credit card number" do
      {
        "6011000990139424"                                => "XXXXXXXXXXXXXXXX",
        "6011111111111117"                                => "XXXXXXXXXXXXXXXX",
        "6011072668180642"                                => "XXXXXXXXXXXXXXXX",
        "6011 0726 6818 0642"                             => "XXXX XXXX XXXX XXXX",
        "6011 0726 6818-0642"                             => "XXXX XXXX XXXX-XXXX",
        "6011-0726 6818 0642"                             => "XXXX-XXXX XXXX XXXX",
        "Starbucks Store #555 6011 0726 6818 0642"        => "Starbucks Store #555 XXXX XXXX XXXX XXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a JCB credit card number" do
      {
        "3566002020360505"                                => "XXXXXXXXXXXXXXXX",
        "3530111333300000"                                => "XXXXXXXXXXXXXXXX",
        "3088877850235318"                                => "XXXXXXXXXXXXXXXX",
        "3088 877850235318"                               => "XXXX XXXXXXXXXXXX",
        "3088-8778-5023-5318"                             => "XXXX-XXXX-XXXX-XXXX",
        "Starbucks Store #555 3088 8778 5023 5318"        => "Starbucks Store #555 XXXX XXXX XXXX XXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a MasterCard credit card number" do
      {
        "5555555555554444"                                => "XXXXXXXXXXXXXXXX",
        "5157387747088202"                                => "XXXXXXXXXXXXXXXX",
        "5105105105105100"                                => "XXXXXXXXXXXXXXXX",
        "5105 1051 0510 5100"                             => "XXXX XXXX XXXX XXXX",
        "5105-1051-0510-5100"                             => "XXXX-XXXX-XXXX-XXXX",
        "5105 1051-0510 5100"                             => "XXXX XXXX-XXXX XXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Visa credit card number" do
      {
        "4222222222222220"                                => "XXXXXXXXXXXXXXXX",
        "4012888888881881"                                => "XXXXXXXXXXXXXXXX",
        "4111111111111111"                                => "XXXXXXXXXXXXXXXX",
        "4532026721946154"                                => "XXXXXXXXXXXXXXXX",
        "4532 0267 2194 6154"                             => "XXXX XXXX XXXX XXXX",
        "4532-0267-2194-6154"                             => "XXXX-XXXX-XXXX-XXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Switch credit card number" do
      {
        "5641826302446333"                                => "XXXXXXXXXXXXXXXX",
        "6331-1005-9051-1593"                             => "XXXX-XXXX-XXXX-XXXX",
        "491192979470860192"                              => "XXXXXXXXXXXXXXXXXX", # 18-digit
        "564182951770215274"                              => "XXXXXXXXXXXXXXXXXX", # 18-digit
        "4903263854966737499"                             => "XXXXXXXXXXXXXXXXXXX", # 19-digit
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Solo credit card number" do
      {
        "6334850405102841"                                => "XXXXXXXXXXXXXXXX",
        "6767 7753 0761 8444"                             => "XXXX XXXX XXXX XXXX",
        "6334-5957-4704-4538"                             => "XXXX-XXXX-XXXX-XXXX",
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Dankort credit card number" do
      {
        "5019600906451260"                                => "XXXXXXXXXXXXXXXX",
        "5019 2174 5298 6407"                             => "XXXX XXXX XXXX XXXX",
        "5019-4930-7205-0938"                             => "XXXX-XXXX-XXXX-XXXX",
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    # maestro CC # can be 12-19 digits
    context "when value contains a Maestro credit card number" do
      {
        "5094730275858403"                                => "XXXXXXXXXXXXXXXX",
        "5000-7429-6277"                                  => "XXXX-XXXX-XXXX", # 12-digit
        "6957-0438-4355-62"                               => "XXXX-XXXX-XXXX-XX", # 14-digit
        "6848 4263 2113 25499"                            => "XXXX XXXX XXXX XXXXX", # 17-digit
        "6878817132178558380"                             => "XXXXXXXXXXXXXXXXXXX", # 19-digit
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Forbrugsforeningen credit card number" do
      {
        "6007221289345722"                                => "XXXXXXXXXXXXXXXX",
        "6007 2295 6187 0234"                             => "XXXX XXXX XXXX XXXX",
        "6007-2215-2343-5149"                             => "XXXX-XXXX-XXXX-XXXX",
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains a Laser credit card number" do
      {
        "6709202628830898"                                => "XXXXXXXXXXXXXXXX",
        "6304-0626-5252-903482"                           => "XXXX-XXXX-XXXX-XXXXXX", # 18-digit
        "6706 2312 0102 8896786"                          => "XXXX XXXX XXXX XXXXXXX", # 19-digit
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value has an uncommon length" do
      {
        "4222222222222"          => "XXXXXXXXXXXXX",          # 13-digit visa (do these exist anymore?)
        "4222-2222-2222-2"       => "XXXX-XXXX-XXXX-X",       # 13-digit visa
        "4234567890123456782"    => "XXXXXXXXXXXXXXXXXXX",    # 19-digit visa (do these exist yet?)
        "4234-5678-9012-3456782" => "XXXX-XXXX-XXXX-XXXXXXX", # 19-digit visa
        "3607050000000000008"    => "XXXXXXXXXXXXXXXXXXX",    # 19-digit diners
        "3607-050000-000000008"  => "XXXX-XXXXXX-XXXXXXXXX",  # 19-digit diners
        "6544440044440046990"    => "XXXXXXXXXXXXXXXXXXX",    # 19-digit discover
        "6544 4400 4444-0046990" => "XXXX XXXX XXXX-XXXXXXX", # 19-digit discover
        "3569990010082211774"    => "XXXXXXXXXXXXXXXXXXX",    # 19-digit jcb
        "3569 9900 1008 2211774" => "XXXX XXXX XXXX XXXXXXX", # 19-digit jcb
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "when value contains multiple credit card numbers" do
      {
        "4012888888881881,4012888888881881"                  => "XXXXXXXXXXXXXXXX,XXXXXXXXXXXXXXXX",
        "4222222222222 5555555555554444"                     => "XXXXXXXXXXXXX XXXXXXXXXXXXXXXX",
        "3566002020360505\n6011000990139424\n30569309025904" => "XXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXXXX\nXXXXXXXXXXXXXX",
        "4532-0267-2194-6154 and 6011111111111117"           => "XXXX-XXXX-XXXX-XXXX and XXXXXXXXXXXXXXXX"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "with a custom replacement character" do
      subject { described_class.new(:replacement_token => "*") }
      {
        "not a cc number"       => "not a cc number",
        "378282246310005"       => "***************",
        "5434 7318 4453 9705"   => "**** **** **** ****",
        "6011072668180642"      => "****************",
        "5157387747088202"      => "****************",
        "4532-0267-2194-6154"   => "****-****-****-****"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "with a non-zero expose_last" do
      subject { described_class.new(:expose_last => 4) }
      {
        "not a cc number"       => "not a cc number",
        "378282246310005"       => "XXXXXXXXXXX0005",
        "5434 7318 4453 9705"   => "XXXX XXXX XXXX 9705",
        "6011072668180642"      => "XXXXXXXXXXXX0642",
        "5157387747088202"      => "XXXXXXXXXXXX8202",
        "4532-0267-2194-6154"   => "XXXX-XXXX-XXXX-6154"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "with a custom replacement character and non-zero expose_last" do
      subject { described_class.new(:replacement_token => "#", :expose_last => 2) }
      {
        "not a cc number"       => "not a cc number",
        "378282246310005"       => "#############05",
        "5434 7318 4453 9705"   => "#### #### #### ##05",
        "6011072668180642"      => "##############42",
        "5157387747088202"      => "##############02",
        "4532-0267-2194-6154"   => "####-####-####-##54"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end

    context "with replacement text" do
      # When replacement_text is set, replacement_token and expose_last are ignored.
      subject { described_class.new(:replacement_text => "[MASKED]", :replacement_token => "%", :expose_last => 3) }
      {
        "not a cc number"       => "not a cc number",
        "pls 378282246310005"   => "pls [MASKED]",
        "5434 7318 4453 9705"   => "[MASKED]",
        "6011072668180642 ok"   => "[MASKED] ok",
        "5157387747088202"      => "[MASKED]",
        "4532-0267-2194-6154"   => "[MASKED]"
      }.each do |value, masked_value|
        it { expect(subject.mask(value)).to eq(masked_value) }
      end
    end
  end
end
