require 'test_helper'
require 'byebug'

class PaypalExpressRestTest < Test::Unit::TestCase
  def setup
    Base.mode = :test
    @paypal_customer = ActiveMerchant::Billing::PaypalCustomerGateway.new
    params = { username: "ASs8Osqge6KT3OdLtkNhD20VP8lsrqRUlRjLo-e5s75SHz-2ffMMzCos_odQGjGYpPcGlxJVQ5fXMz9q",
               password: "EKj_bMZn0CkOhOvFwJMX2WwhtCq2A0OtlOd5T-zUhKIf9WQxvgPasNX0Kr1U4TjFj8ZN6XCMF5NM30Z_" }

    params = { username: "AeLico9_Zr8qxYi5jO78egnG7wgSEz8-yQDk0sLDplQTBc_NvCpVSqBjpw2fw6bYZsNJyoZezWCBks4G",
               password: "EG3CEcnR73U55aTP6Q5mGFZusEsNzn-H7HpAebiF1JeLFQh4AdTiJ393VerSXKXDK_j_NYMBv5g5PpgW" }


    options = { "Content-Type": "application/json", authorization: params }
    bearer_token = @paypal_customer.require!(options)
    @headers = { "Authorization": "Bearer #{ bearer_token[:access_token] }", "Content-Type": "application/json" }

    @body = {
        "intent": "CAPTURE",
        "purchase_units": [
            {
                "reference_id": "camera_shop_seller_#{DateTime.now}",
                "description": "Camera Shop",
                "amount": {
                    "currency_code": "USD",
                    "value": "12.00",
                    "breakdown": {
                        "item_total": {
                            "currency_code": "USD",
                            "value": "12.00"
                        },
                        "shipping": {
                            "currency_code": "USD",
                            "value": "0"
                        },
                        "handling": {
                            "currency_code": "USD",
                            "value": "0"
                        },
                        "tax_total": {
                            "currency_code": "USD",
                            "value": "0"
                        },
                        "gift_wrap": {
                            "currency_code": "USD",
                            "value": "0"
                        },
                        "shipping_discount": {
                            "currency_code": "USD",
                            "value": "0"
                        }
                    }
                },
                "payee": {
                    "email_address": "sb-jnxjj3033194@business.example.com"
                },
                "items": [
                    {
                        "name": "Levis 501 Selvedge STF",
                        "sku": "5158936",
                        "unit_amount": {
                            "currency_code": "USD",
                            "value": "12.00"
                        },
                        "tax": {
                            "currency_code": "USD",
                            "value": "0.00"
                        },
                        "quantity": "1",
                        "category": "PHYSICAL_GOODS"
                    }
                ],
                "shipping": {
                    "address": {
                        "address_line_1": "123 Townsend St",
                        "address_line_2": "Floor 6",
                        "admin_area_2": "San Francisco",
                        "admin_area_1": "CA",
                        "postal_code": "94107",
                        "country_code": "US"
                    }
                },
                "shipping_method": "United Postal Service",
                "payment_instruction": {
                    "disbursement_mode": "INSTANT",
                    "platform_fees": [
                        {
                            "amount": {
                                "currency_code": "USD",
                                "value": "2.00"
                            },
                            "payee": {
                                "email_address": "sb-jnxjj3033194@business.example.com"
                            }
                        }
                    ]
                },
                "payment_group_id": 1,
                "custom_id": "custom_value_#{DateTime.now}",
                "invoice_id": "invoice_number_#{DateTime.now}",
                "soft_descriptor": "Payment Camera Shop"
            }
        ],
        "application_context": {
            "return_url": "https://google.com",
            "cancel_url": "https://google.com"
        }
    }

    @options = { headers: @headers, body: @body }
  end


  def test_set_customer_order_creation
    paypal_customer = ActiveMerchant::Billing::PaypalCustomerGateway.new
    response = paypal_customer.create_order(@options)
    debugger
    assert response.success?
    assert response.parsed_response["status"].eql?("CREATED")
    assert !response.parsed_response["id"].nil?
    assert !response.parsed_response['links'].blank?
  end
end
