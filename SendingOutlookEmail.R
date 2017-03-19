library(RDCOMClient)
library(ggplot2)

# Create a simple scatterplot with ggplo2
SimplePlot <- ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
# Create a temporary file path for the image that we will attach to our email
SimplePlot.file <- tempfile(fileext = ".png")
# Save the ggplot we just created as an image with the temporary file path
ggsave(plot = SimplePlot, file = SimplePlot.file,
       device = "png", width = 4, height = 4)

# Create an Outlook object, a new email, and set the parameters.
Outlook <- COMCreate("Outlook.Application")
Email <- Outlook$CreateItem(0)
Email[["To"]] <- "johnsmith@example.com"
Email[["subject"]] <- "A simple scatterplot"
# Some text before we insert our plot
Body <- "<p>Your scatterplot is here:</p>"

# First add the temporary file as an attachment.
Email[["Attachments"]]$Add(SimplePlot.file)
# Refer to the attachment with a cid
# "basename" returns the file name without the directory.
SimplePlot.inline <- paste0( "<img src='cid:",
                             basename(SimplePlot.file),
                             "' width = '400' height = '400'>")
# Put the text and plot together in the body of the email.
Email[["HTMLBody"]] <- paste0(Body, SimplePlot.inline)

# Either display the email in Outlook or send it straight away.
# Comment out either line.
Email$Display()
#Email$Send()

# Delete the temporary file used to attach images.
unlink(SimplePlot.file)