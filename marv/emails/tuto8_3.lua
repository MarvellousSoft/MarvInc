return {
    title = "Number limits",
    text = [[
As you probably know by now, %addr% register %num% contents %end% can hold %num% values %end% from -999 to 999. This tasks asks for the square of a number up to 30, that is convenient, since that value is less than 999. But what happens when we perform an operation that takes us out of these bounds?

Even a simple operation like [ %inst% add %num% 500 500 %addr% 0 %end% ] brings this doubt. Will the value in %addr% register #0 %end% be 999? Or will it throw a Runtime Error? Actually, none of those. The value will be -999. Why is that? You could think that the numbers are cyclical, they go from -999 to 999, and the number after 999 is -999.
So we have:

 500 + 500 = -999
 -600 - 500 = 899 and
 50 * 50 = 501.

A good robot specialist should know these things. You may one day need it.

Keep your eyes open, and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
