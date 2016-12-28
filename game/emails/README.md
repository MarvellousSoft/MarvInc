## Emails

To create an email, you should create a file that returns a table with the following fields:
- **title**: email title
- **text**: email content
- **author**: email author
- **can_be_deleted**: whether there is a delete button for this email (defaults to false)
- **puzzle_id**: if this email creates a puzzle, then the puzzle id, otherwise nil
- **open_func**: function to be called the first time the email is read
- **reply_func**: function to be called when the reply button is pressed

The email will have a reply button if either reply\_func or puzzle\_id are not nil. If puzzle\_id is not nil, then pressing reply automatically switches to the puzzle.
The email will have a delete button if can\_be\_deleted is true.
