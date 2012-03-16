# Guard::Grit
[Guard](https://github.com/guard/guard) is a ruby gem that allows commands to be run automatically when files in watched directories are modified.

The guard-grit gem is for intereacting with your git repo automatically.  It uses [Grit](https://github.com/mojombo/grit) in the background to do as much as possible, and shells out to the git command where Grit doesn't cover the needed functionality.

## UNDER DEVELOPMENT
Work is still proceeding on guard-grit and it is not ready to be used anywhere much less production.

I am using this as an experiment for ways to do self-adding modules, so that is why the module includes are so complicated.  If this takes off I'll prolly refactor those to be a bit simpler.

## Intended Usage

Guard Grit will support the following functionality.  Each can be turned on or off individually.

  * Auto Branch.  When guard is started it will create a new branch for this session.  When guard exits, it will merge all of the commits on the new branch back into the original as a single commit.  This makes the Auto Commit feature more useful.  Branch name can be set explicity or can be generated from the existing branch name.
  * Auto Stage.  Automatically stage Modified, Deleted, and Moved(?), Automatically add new files.  May eventually be Auto Track, Auto Stage, Auto RM, and Auto MV.  Not sure if these work best as a single feature or as separate ones.
  * Auto Commit.  Automatically commit staged files to the repo.  Should be able to tie to the successful running of tests/specs/features.  Should be able to set a minimum time span between commits.  Will depend on maunal staging or Auto Adds.
  * Status.  Give a short summary of the repo.  Should be able to be a single or multi line template, colorized as needed.

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continue.

Install the gem:

    $ gem install guard-grit

Add it to your Gemfile (inside development group):

``` ruby
group :development do
  gem 'guard-grit'
end
```

Add guard definition to your Guardfile by running this command:

    $ guard init grit

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme)

## Guardfile

``` ruby
guard 'grit' do
  watch(%r(\.*)
end
```

Please read [Guard doc](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

By default, Guard::Grit automatically sets the repo to the current directory.  You can configure it for another repo by passing ```:repo_dir```` as an option.

``` ruby
guard 'grit', :repo_dir => ".." do
  # ...
end
```

### List of available options:

``` ruby
:repo_dir => Dir.pwd              # The directory to use when initializing the @repo object.

#Auto Branch Feature
:auto_branch => false             # use the Auto Branch feature
:auto_branch_name => false        # explicitly set the branch name to use when using auto branch
:auto_branch_prefix => :auto      # string, symbol or array of string/symbol used to construct a auto branch name from the current branch name.  These parts appear before the current branch name.
:auto_branch_suffix => nil        # As prefix, but appears after current branch name.
:auto_branch_separator => "/"     # insert this as a separator between Prefix, current branch name, and suffix parts.
:auto_branch_merge_back => true   # Merge auto branch back to original branch on Guard Stop.

#The rest of these are subject to change

#Auto Staging feature 
:auto_stage => false              # use the Auto Staging feature

#Auto Commit feature
:auto_commit => false             # use the Auto Commit feature

#Status feature
:status => true                   # use the Status feature
```

## Development

* Source hosted at [GitHub](https://github.com/anithri/guard-grit)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/anithri/guard-grit/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

## Testing


## Author

[Scott Parrish](https://github.com/anithri)
