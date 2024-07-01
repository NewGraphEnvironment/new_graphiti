my_dt_table <-   function(dat,
                          cols_freeze_left = 3,
                          page_length = 10,
                          col_align = 'dt-center', #'dt-right',
                          font_size = '10px',
                          style_input = 'bootstrap'){

  dat |>
    DT::datatable(
      style = style_input,
      class = 'cell-border stripe', #'dark' '.table-dark',
      #https://stackoverflow.com/questions/36062493/r-and-dt-show-filter-option-on-specific-columns
      filter = 'top',
      extensions = c("Buttons","FixedColumns", "ColReorder"),
      rownames= FALSE,
      options=list(
        scrollX = TRUE,
        columnDefs = list(list(className = col_align, targets = "_all")), ##just added this
        pageLength = page_length,
        dom = 'lrtipB',
        buttons = c('excel','csv'),
        fixedColumns = list(leftColumns = cols_freeze_left),
        lengthMenu = list(c(5,10,25,50,-1),
                          c(5,10,25,50,"All")),
        colReorder = TRUE,
        #https://stackoverflow.com/questions/45508033/adjusting-height-and-width-in-dtdatatable-r-markdown
        rowCallback = htmlwidgets::JS("function(r,d) {$(r).attr('height', '100px')}"),
        #https://stackoverflow.com/questions/44101055/changing-font-size-in-r-datatables-dt
        initComplete = htmlwidgets::JS(glue::glue(
          "function(settings, json) {{ $(this.api().table().container()).css({{'font-size': '{font_size}'}}); }}"
        ))
        #https://github.com/rstudio/DT/issues/1085 - this is not working yet
        #   initComplete = JS(
        #     'function() {$("html").attr("data-bs-theme", "dark");}')
      )
    )
}

ltab_caption <- function(caption_text = my_caption) {
  cat(
    "<table>",
    paste0(
      "<caption>",
      "(#tab:",
      # this is the chunk name!!
      knitr::opts_current$get()$label,
      ")",
      caption_text,
      "</caption>"
    ),
    "</table>",
    sep = "\n"
  )
}
