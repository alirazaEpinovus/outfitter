const String checkoutmutation = """
mutation customerCheckout(\$Checkoutitems : [CheckoutLineItemInput!])
{
  checkoutCreate(input: {
    lineItems: \$Checkoutitems
  }) {
    checkout {
      id
      webUrl
      lineItems(first: 5) {
         edges {
          node {
             title
             quantity
          }
         }
      }
    }
  }
}
""";


String signUp = """
  mutation customerCreate(\$input: CustomerCreateInput!) {
  customerCreate(input: \$input) {
    customer {
      id
      email
    }
    customerUserErrors {
      code
      field
      message
    }
  }
}""";


String newLetterSubcribe = """
  mutation customerCreate(\$input: CustomerCreateInput!) {
  customerCreate(input: \$input) {
    customer {
      id
      email
    }
    customerUserErrors {
      code
      field
      message
    }
  }
}""";

 String shopifyLogin="""
  mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) {
  customerAccessTokenCreate(input: \$input) {
    customerUserErrors {
    code
    field
    message
    }
    customerAccessToken {
    accessToken
    expiresAt
   }
  }
  }""";

    String resetPassword="""
 mutation customerRecover(\$email: String!) {
  customerRecover(email: \$email) {
    customerUserErrors {
      code
      field
      message
    }
  }
}""";

const String checkoutmutationwithemail = """
mutation customerCheckout(\$Checkoutitems : [CheckoutLineItemInput!],\$email : String)
{
  checkoutCreate(input: {
    lineItems: \$Checkoutitems, email : \$email
  }) {
    checkout {
      id
      webUrl
      lineItems(first: 5) {
         edges {
          node {
             title
             quantity
          }
         }
      }
    }
  }
}
""";
  