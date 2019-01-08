curl \
--connect-timeout 5 \
--header "content-type: text/soap+xml; charset=utf-8" \
--data @/callWSv2/ws_soap_request.xml \
http://example.com/services/ExampleService.ExampleServiceV2HttpSoap11Endpoint/
