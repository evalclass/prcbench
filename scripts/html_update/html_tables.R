get_html_table <- function(tab_name) {
  func_name <- get(paste0("get_tab_", tab_name))
  func_name()
}

get_tab_predefined_datasets <- function() {
  c(
    "<table class=\"table\">",
    "   <tr>",
    "      <td>",
    "         <strong>set name</strong>",
    "      </td>",
    "      <td>",
    "         <strong><code>S3</code> object</strong>",
    "      </td>",
    "      <td> <strong>data source</strong> </td>",
    "   </tr>",
    "   <tr>",
    "      <td>",
    "         c1 or C1",
    "      </td>",
    "      <td> <code><a href='TestDataC.html'>TestDataC</a></code> </td>",
    "      <td> <code><a href='C1DATA.html'>C1DATA</a></code>   </td>",
    "   </tr>",
    "   <tr>",
    "      <td>",
    "         c2 or C2",
    "      </td>",
    "      <td> <code><a href='TestDataC.html'>TestDataC</a></code> </td>",
    "      <td> <code><a href='C2DATA.html'>C2DATA</a></code>   </td>",
    "   </tr>",
    "   <tr>",
    "      <td>",
    "         c3 or C3",
    "      </td>",
    "      <td> <code><a href='TestDataC.html'>TestDataC</a></code> </td>",
    "      <td> <code><a href='C3DATA.html'>C3DATA</a></code>   </td>",
    "   </tr>",
    "   <tr>",
    "      <td>",
    "         c4 or C4",
    "      </td>",
    "      <td> <code><a href='TestDataC.html'>TestDataC</a></code> </td>",
    "      <td> <code><a href='C4DATA.html'>C4DATA</a></code>   </td>",
    "   </tr>",
    "</table>"
  )
}
