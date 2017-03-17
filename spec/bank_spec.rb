require 'spec_helper'

WEBSITE_ID = 1234
SECRET_KEY = "secrete key"

describe VtcPayment::Bank::Request do
  let(:req) { VtcPayment::Bank::Request::Bank::Vietcombank.new("ACCOUNT", 9999, "SECRET_KEY", "https://your.web.site/") }
  before do
    @params = {
      amount: 100_000, # VND
      order_id: "123456789",
    }
  end
  it 'generates a url' do
    req.sandbox = true
    url = req.url(@params)
    expected_url = "http://sandbox1.vtcebank.vn/pay.vtc.vn/cong-thanh-toan/checkout.html?website_id=9999&payment_method=1&order_code=123456789&amount=100000&receiver_acc=ACCOUNT&urlreturn=https%3A%2F%2Fyour.web.site%2F&customer_first_name=&customer_last_name=&customer_mobile=&bill_to_address_line1=&bill_to_address_line2=&city_name=&address_country=&customer_email=&order_des=&param_extend=PaymentType%3ABank%3BDirect%3AVietcombank&sign=B83F15BAF9A6D1C0E5EC73BDF706CDD828EC182C50E1E9CD27C2801A59A4E923"
    is_asserted_by { url == expected_url }
  end
end
