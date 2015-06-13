# Getting Set Up for this Class

This class assumes that you have a development environment with Perl and Moose installed, as well as a few other perl modules.

## Installing Perl

This class should work with Perl back to 5.8.8. That said, I recommend installing a newer Perl than that if possible. There's no reason not to choose the latest stable version of Perl. You can use tools such as [plenv](https://github.com/tokuhirom/plenv) or [perlbrew](http://perlbrew.pl/) to easily install local versions of Perl.

## Installing Moose

I highly recommend that you install the cpanminus tool. If you're using perlbrew just run `perlbrew install-cpanm`. With plenv run `plenv install-cpanm`. See the [cpanminus docs](https://metacpan.org/pod/App::cpanminus) for more options.

Once you have cpanm installed you can install Moose and the required test modules with `cpanm Moose Test::Harness Test::More`.

## Reading the Slides

These slides are simply an HTML file. You can open the file at `slides/index.html` to view the slides.

## Exercises

See the [exercises/README.md file](exercises/README.md) for more details on the exercises.

