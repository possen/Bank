# Bank

Project demonstrates various approaches with dealing with async data by using Bright Futures. This includes testing the asynchonous loading of table view under a unit test.

- BrightFutures handles the asynchronous chaining of the requests and does the parsing off the main thread, thus avoiding heavily nested handlers. 
- The ViewControllerTests shows the view controller and how to do some testing of a view controller.
- TableViewAdaptor now handles a table where the number of sections changes after receiving data.
