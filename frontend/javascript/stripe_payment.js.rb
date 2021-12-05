class StripePayment < HTMLElement
  PRIMARY_COLOR = "#0284c7"

  custom_elements.define "stripe-payment", StripePayment

  def stripe
    @stripe ||= Stripe(self.get_attribute("public-key"))
  end

  async def display(raw_amount)
    amount = raw_amount.to_f

    unless amount
      show_error("The amount you entered isn't a valid number. Please try again.")
      self.closest("sl-dialog").open = false
      set_timeout 3000 do
        location.reload()
      end
      return
    end

    footer = self.query_selector("stripe-payment-footer")
    self.inner_html = %(<form id="stripe-payment-form"><div id="stripe-payment-element" style="min-height:220px"></div></form>)
    if footer
      self.query_selector("form").append_child(footer)
      footer.query_selector("sl-button").add_event_listener(:click) do
        handle_submit()
      end
      footer.query_selector("sl-button span").textContent = "$#{amount}"
    end
    self.loading = true

    api_url = self.get_attribute(:href)

    response = await fetch(
      api_url,
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: { amount: amount }.to_json
    )
    data = await response.json()
    client_secret = data.client_secret

    appearance = {
      theme: 'stripe',
      variables: {
        color_primary: PRIMARY_COLOR,
      },
    }
    @elements = stripe.elements(appearance: appearance, client_secret: client_secret)

    payment_element = @elements.create("payment")
    payment_element.mount "#stripe-payment-element"
    self.loading = false
  end

  async def handle_submit(e = nil)
    e.prevent_default() if e
    self.loading = true

    payment_response = await stripe.confirm_payment(
      elements: @elements,
      confirm_params: {
        "return_url" => self.get_attribute("return-href"),
        "payment_method_data" => {
          "billing_details" => {
            email: self.query_selector("stripe-payment-footer sl-input[name='email']").value
          }
        }
      }
    )

    show_error("Oops! <strong>#{payment_response.error.message}</strong> If you keep seeing this problem, please email jared@whitefusion.studio")

    self.loading = false
  end

  def show_error(message)
    alert = Object.assign(document.create_element('sl-alert'),
      type: :danger,
      closable: true,
      duration: 6000,
      innerHTML: <<~HTML
        <sl-icon library="remixicon" name="system/alert-fill" slot="icon"></sl-icon>
        #{message}
      HTML
    )

    document.body.append(alert)
    alert.toast()
  end

  def loading=(state)
    self.query_selector("stripe-payment-footer sl-button").loading = state
  end
end
