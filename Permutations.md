---
title: Permutations
author: Jonathan Dushoff and Ben Bolker
---

Introduction
============

Classical statistics was developed partly under the [lamppost
theory](lamppost_theory.html): people did not used to have
powerful computers, and therefore there were only certain kinds of
statistics that they could do.

Permutation tests provide a powerful way of testing statistical
hypotheses, and *also of thinking about what your statistical tests
mean*. Thinking about statistical tests in terms of permutations can
help you think clearly about your tests even if you never actually use a
permutation test.

Resources
=========

-   [Permutations_Lecture notes](Permutations_Lecture_notes.html)
-   [more permutation code examples](permutation_examples.html): 

-   R stuff
    -   [R's "conditional inference" (coin)
        package](http://cran.r-project.org/web/packages/coin/index.html)
        -- Very cool, and a little intimidating.
    -   [Information about "permute" and "vegan"
        packages](http://ucfagls.wordpress.com/2011/10/04/permute-a-package-for-generating-restricted-permutations/).
        These seem to be more about generating permutations than doing
        permutation tests
    -   [gtools](http://cran.r-project.org/web/packages/gtools/index.html)


-   Stuff from JD
    -   [Counting and plotting
        permutations](http://lalashan.mcmaster.ca/theobio/math/index.php/Permutation_tests)
    -   [Confidence intervals for the mean of a symmetric
        variable](http://lalashan.mcmaster.ca/ecostats/permmean.pdf)

Assignment
==========

-   Formulate two different hypotheses about your data, and describe how
    you would test them with two different permutation tests. Challenge
    yourself to come up with conceptually different tests, if this is
    reasonable for your data set.
-   Implement one or both of these tests in R. You can use permutation,
    or you can use a classic test if you explain clearly how it
    corresponds to a permutation test. Best would be to use both.

