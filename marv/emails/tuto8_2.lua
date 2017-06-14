return {
    title = "New ways to handle values",
    text = [=[
Since you've reached this far, you have proven yourself almost qualified to work on our most professional jobs, here at Marvellous Inc. Here are some advanced ways to manipulate values and addresses.

You already know that [8] represents the value inside the register #8, but did you know you can also write [[8]]? This returns the content inside the register whose number is the content inside the register 8! This may sound confusing, but here is an example so you can better understand.

We have the register #1 with the content 50, and the register #5 with the content 1. Now look at the following code:
    - walk [[5]]

This will make the robot walk 50 spaces forward, since [5] equals to 1, and [1] equals to 50.

You can keep adding []'s as many times as you like to a value, such as [[[[5]]]], referencing deeper and deeper registers. Just make sure you won't try to access a register with an invalid number.

As an almost professional in this area, you should learn well this technique, since it will be crucial for more challenging jobs.

Another possibility is using registers to store numeric labels. That means "jmp [5]" will jump to the label that is stored in register #5. If there is no such label with that number, you will get an error. You probably won't need this soon, but it is always better to know.

Never stop learning, and carry on.
]=],
    author = "Automated Introduction System",
    can_be_deleted = true
}
