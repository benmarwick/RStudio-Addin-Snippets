context('inserting pipe')

source('common.R')

load('.foobar.Rdata')

# value is the line number of the line: '# dummy method'
test.first.line <- 15

test_that('resolve.position',
{
    context <- my.setSelectionRange(top.context, c(test.first.line + 15, 1, test.first.line + 19,  9))
    positions <- lapply(context[['selection']], '[[', 'range')
    indentation <- 4

    expect_identical( resolve.selection(context, positions[[1]], indentation)
                    , list(range=rstudioapi::document_range(
                                      rstudioapi::document_position(test.first.line + 14,  0)
                                    , rstudioapi::document_position(test.first.line + 19, 17))
                          , text='    a <- select() %>%\n        filter()'
                          , column=8))
})

test_that('update.positions',
{
    positions <- list( rstudioapi::document_range(
                            rstudioapi::document_position(test.first.line + 14, 27)
                          , rstudioapi::document_position(test.first.line + 19,  9))
                     , rstudioapi::document_range(
                            rstudioapi::document_position(test.first.line + 19, 17)
                          , rstudioapi::document_position(test.first.line + 19, 17))
                     )
    expected <- list( rstudioapi::document_position(test.first.line + 15, 9)
                    , rstudioapi::document_range(
                            rstudioapi::document_position(test.first.line + 15, 17)
                          , rstudioapi::document_position(test.first.line + 15, 17))
                    )
    positions <- update.positions(positions, 1, test.first.line + 14, 8)
    expect_identical(positions, expected)


    expected <- list( rstudioapi::document_position(test.first.line + 15, 9)
                    , rstudioapi::document_position(test.first.line + 16, 13))
    positions <- update.positions(positions, 2, test.first.line + 15, 12)
    expect_identical(positions, expected)
})

test_that('insert.pipe',
{
    # skip when it's not RStudio or it's of a version that doesn't support addins
    skip_if_not(rstudioapi::isAvailable(REQUIRED.RSTUDIO.VERSION), 'RStudio is not available!')

    # backup original text
    rstudioapi::setSelectionRanges(
        rstudioapi::document_range(
            rstudioapi::document_position(test.first.line,      1)
          , rstudioapi::document_position(test.first.line + 28, 2)
        )
    )
    orig <- rstudioapi::primary_selection(rstudioapi::getActiveDocumentContext())$text

    # expected result (included in the code example above)
    rstudioapi::setSelectionRanges(
        rstudioapi::document_range(
            rstudioapi::document_position(test.first.line + 23, 1)
          , rstudioapi::document_position(test.first.line + 25, 9)
        )
    )
    expected <- rstudioapi::primary_selection(rstudioapi::getActiveDocumentContext())$text

    rstudioapi::setCursorPosition(list( rstudioapi::document_range(
                                            rstudioapi::document_position(test.first.line + 14, 27)
                                          , rstudioapi::document_position(test.first.line + 19,  9))
                                      , rstudioapi::document_position(test.first.line + 19, 17)))

    insert.pipe()

    # collect final position of cursors
    actual.1 <- rstudioapi::getActiveDocumentContext()$selection

    # collect text output
    rstudioapi::setSelectionRanges(
        rstudioapi::document_range(
            rstudioapi::document_position(test.first.line + 14, 1)
          , rstudioapi::document_position(test.first.line + 16, 9)
        )
    )
    actual.2 <- rstudioapi::primary_selection(rstudioapi::getActiveDocumentContext())$text

    # restore original content
    rstudioapi::modifyRange(
        rstudioapi::document_range(
            rstudioapi::document_position(test.first.line,      1)
          , rstudioapi::document_position(test.first.line + 25, 2)
    )
      , orig
    )

    expect_identical(actual.1[[1]]$range, rstudioapi::document_range(
                                            rstudioapi::document_position(test.first.line + 15, 9)
                                          , rstudioapi::document_position(test.first.line + 15, 9)))
    expect_identical(actual.1[[1]]$text, '')

    expect_identical(actual.1[[2]]$range, rstudioapi::document_range(
                                            rstudioapi::document_position(test.first.line + 16, 13)
                                          , rstudioapi::document_position(test.first.line + 16, 13)))
    expect_identical(actual.1[[2]]$text, '')

    expect_identical(actual.2, expected)
})
