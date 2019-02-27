
= Scripts

This directory contains helper scripts for setting up the database. After importing the powershell module,
`Invoke-DatabaseFile` can be used to create the database and `Invoke-PopulateDatabase` can be used
to populate it from the published data. Note that `Invoke-PopulateDatabase` does not sanitize the data,
it requires that the csv values are not encosed in quotations.

=== Commentary
It would be nice if I wrote a helper function to automatically grab the data from the internet and
sanitize it for the scripts. But the data is rather large for my internet connection so it would
take too long to test.

There also isn't any way to migrate the database since I don't plan on doing that for this project.
