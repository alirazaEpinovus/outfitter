const String readCollection = """
  query ReadCollection(\$CollectionId: ID!, \$shortkey: ProductCollectionSortKeys!, \$rev: Boolean!,\$cursor :String ) {
    
      node(id: \$CollectionId) {
    ... on Collection {
      id
      title
      description
      products(first:25,sortKey: \$shortkey, reverse: \$rev,after: \$cursor) {
         pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor 
          node {
            title
            tags
            description
            availableForSale
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
                     options(first: 4) {
        values
        name
      }
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight:900, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
        }
      }
    }
  }
  }

""";

// const String filterCollection = """
//  query filterCollection(\$query: String!, \$rev: Boolean!,\$cursor :String ) {
//        products(first: 50,query: \$query, reverse: \$rev,after: \$cursor) {
//          pageInfo {
//           hasNextPage
//           hasPreviousPage
//         }
//         edges {
//           cursor
//           node {
//             title
//             tags
//             description
//             descriptionHtml
//             productType
//             publishedAt
//             onlineStoreUrl

//             variants(first: 10) {
//               edges {
//                 node {
//                   id
//                   image(maxHeight: 1200, maxWidth:900) {
//                     src
//                   }
//                   price
//                   sku
//                   compareAtPrice
//                   availableForSale
//                   available
//                   selectedOptions {
//                     name
//                     value
//                   }
//                 }
//               }
//             }
//             images(first: 30,maxHeight: 1200, maxWidth:900) {
//               edges {
//                 node {
//                   src
//                 }
//               }
//             }
//             id
//           }
//         }
//       }
//     }

// """;
const String filterCollection = """
query filterCollection(\$rev: Boolean!,\$cursor :String, \$query:String! ) {
       products(first: 20,query:\$query, reverse: \$rev,after: \$cursor) {
         pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            title
            tags
            description
            availableForSale
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
                     options(first: 4) {
        values
        name
      }
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight:900, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
        }
      }
    }
""";
const String productfetch = """
query fetcgProduct(\$productid : ID!){
  node(id: \$productid) {
    ... on Product {
            title
            tags
            description
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight:900, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
    }
  }
""";
const String searchProducts = """
  query ReadProductsByTag(\$Search: String!) {
    
      products(first: 20,query: \$Search) {
        
         pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            title
            tags
            availableForSale
            description
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
              options(first: 4) {
        values
        name
      }
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight: 1000, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
        }
      }
    }
""";
String readProductDetails = """
  query ReadProduct(\$ProductId: ID!) {
     node(id: \$ProductId) {
    ... on Product {
      id
      title
      description
      productType
      descriptionHtml
      availableForSale
      onlineStoreUrl
      options(first: 4) {
        values
        name
      }
      tags
      images(first: 30) {
        edges {
          node {
            src
            altText
          }
        }
      }
      variants(first: 30) {
        edges {
          node {
            id
            price
            title
            available
            availableForSale
            compareAtPrice
           image(maxHeight: 300, maxWidth: 150){
              src
            }
            sku
            selectedOptions {
              value
            }
          }
        }
      }
    }
  }
  }
""";
const String getproductsfromtags = """
  query ReadProductsByTag(\$Tag: String!, \$cursor :String) {
    
     
      products(first: 250,query: \$Tag, after: \$cursor) {
        
         pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            title
            tags
            description
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight:900, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
        }
      }
    }
""";

const String readProfileData = """
query readUserProfileData (\$customerAccessToken : String!){
  customer(customerAccessToken: \$customerAccessToken) {
    id
    firstName
    lastName
    phone
    createdAt
    email
  }
}
""";

const String scanAndShopProduct = """
 query ReadProductsByTag(\$sku: String!) {
      products(first: 100,query: \$sku) {
        
         pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            title
            tags
            description
            descriptionHtml
            productType
            publishedAt
            onlineStoreUrl
                            options(first: 4) {
        values
        name
      }
            variants(first: 30) {
              edges {
                node {
                  id
                  image(maxHeight:900, maxWidth: 550) {
                    src
                  }
                  price
                  sku
                  compareAtPrice
                  availableForSale
                  available
                  selectedOptions {
                    name
                    value
                  }
                }
              }
            }
            images(first: 30,maxHeight:900, maxWidth: 550) {
              edges {
                node {
                  src
                  altText
                }
              }
            }
            id
          }
        }
      }
    }


""";

const String readOrders = """
  
 query readUserProfileData (\$accestoken : String!){
    customer(customerAccessToken: \$accestoken) {
    orders(first: 250, reverse: true, sortKey: PROCESSED_AT) {
      pageInfo {
        hasNextPage
        hasPreviousPage
      }
      edges {
        cursor
        node {
          lineItems(first: 250) {
            edges {
              node {
                quantity
                title
                variant {
                  image {
                    src
                  }
                  price
                  product {
                    title
                    createdAt
                    publishedAt
                  }
                  
                }
              }
            }
          }
          totalPrice
          
          orderNumber
          totalShippingPrice
          subtotalPrice
          totalShippingPriceV2 {
            amount
          }
          shippingAddress {
            address1
            address2
          }
          
        }
      }
    }
    displayName
  }
}
  """;
// wfp202065trs-prp
