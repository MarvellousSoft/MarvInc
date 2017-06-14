return {
    title = "New ways to handle values",
    text = [=[
Since you've reached this far, you have proven yourself almost qualified to work on our most professional jobs, here at Marvellous Inc. Here are some advanced ways to manipulate %green% values %end% and %cyan% addresses %end% .

You already know that %green% [8] %end% represents the %green% value %end% inside the %cyan% register #8 %end% , but did you know you can also write %green% [[8]] %end% ? This returns the %green% content %end% inside the %cyan% register %end% whose number is the %green% content %end% inside the %cyan% register 8 %end% ! This may sound confusing, but here is an example so you can better understand.

We have the %cyan% register #1 %end% with the %green% content 50 %end% , and the %cyan% register #5 %end% with the %green% content 1 %end% . Now look at the following code:
    - %red% walk %green% [[5]] %end%

This will make the robot walk %green% 50 %end% spaces forward, since %green% [5] %end% equals to %green% 1 %end% , and %green% [1] %end% equals to %green% 50 %end% .

You can keep adding []'s as many times as you like to a %green% value %end% , such as %green% [[[[5]]]] %end% , referencing deeper and deeper %cyan% registers %end% . Just make sure you won't try to access a %cyan% register %end% with an invalid %green% number %end% .

As an almost professional in this area, you should learn well this technique, since it will be crucial for more challenging jobs.

Another possibility is using %cyan% registers %end% to store numeric %purple% labels %end% . That means [ %red% jmp %green% [5] %end% ] will jump to the %purple% label %end% that is stored in %cyan% register #5 %end% . If there is no such %purple% label %end% with that %green% number %end% , you will get an error. You probably won't need this soon, but it is always better to know.

Never stop learning, and carry on.
]=],
    author = "Automated Introduction System",
    can_be_deleted = true
}
