require 'spec_helper'

WEBSITE_ID = 1234
SECRET_KEY = "secrete key"

describe VtcPayment::MobileCard::Client do
  let(:client) { VtcPayment::MobileCard::Client.new("ACCOUNT", "SECRET_KEY") }
  before do
    @cardid = "123456"
    @cardcode = "1234567"
    @des = "tomokazu"
  end
  it 'generates a xml' do
    client.sandbox = true
    xml = client.build_xml_data(@cardid, @cardcode, @des)
    expected_xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><Request xmlns=\"VTCOnline.Card.WebAPI\"><PartnerID>ACCOUNT</PartnerID><RequestData>DgaTC3b+tHQ9sc6fR3UKs0LHWkz1I+UlVbvZ3cJnL5ttHI5APS23Pex6Bhp4piasE6ocf3r/xQdVxUVQWrNwaOx6Bhp4piasLfGHRULZ9AplAK4aOVlDRw127+shs+f5RxAOiLGq2yUB3m96Jp0+Io1+XtGlGVvpIlFJr4lZJ+KYa8mOZD4r5ux6Bhp4pias77HNp5RwUddrFYncvwY1RBI9L5UQOIlVnKHSfQd8/4nsegYaeKYmrOpr0MCKeM8FSCmPe3dto63FBIFxKtmO4a6R4IKj4Gj129Gy8e1fCulikJHJqYV/fE/lwPdGXR++D25al5Er/cs=</RequestData></Request></soap:Body></soap:Envelope>"
    is_asserted_by { xml == expected_xml }
  end
end
