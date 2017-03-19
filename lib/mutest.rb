require 'abstract_type'
require 'adamantium'
require 'anima'
require 'concord'
require 'digest/sha1'
require 'diff/lcs'
require 'diff/lcs/hunk'
require 'equalizer'
require 'ice_nine'
require 'morpher'
require 'open3'
require 'optparse'
require 'parallel'
require 'parser'
require 'parser/current'
require 'pathname'
require 'regexp_parser'
require 'set'
require 'stringio'
require 'unparser'

# This setting is done to make errors within the parallel
# reporter / execution visible in the main thread.
Thread.abort_on_exception = true

# Library namespace
#
# @api private
module Mutest
  EMPTY_STRING   = ''.freeze
  EMPTY_ARRAY    = [].freeze
  EMPTY_HASH     = {}.freeze
  SCOPE_OPERATOR = '::'.freeze

  # Test if CI is detected via environment
  #
  # @return [Boolean]
  def self.ci?
    ENV.key?('CI')
  end
end # Mutest

require 'mutest/version'
require 'mutest/env'
require 'mutest/env/bootstrap'
require 'mutest/util'
require 'mutest/registry'
require 'mutest/ast'
require 'mutest/ast/sexp'
require 'mutest/ast/types'
require 'mutest/ast/nodes'
require 'mutest/ast/named_children'
require 'mutest/ast/node_predicates'
require 'mutest/ast/regexp'
require 'mutest/ast/regexp/transformer'
require 'mutest/ast/regexp/transformer/direct'
require 'mutest/ast/regexp/transformer/text'
require 'mutest/ast/regexp/transformer/recursive'
require 'mutest/ast/regexp/transformer/quantifier'
require 'mutest/ast/regexp/transformer/options_group'
require 'mutest/ast/regexp/transformer/character_set'
require 'mutest/ast/regexp/transformer/root'
require 'mutest/ast/regexp/transformer/alternative'
require 'mutest/ast/meta'
require 'mutest/ast/meta/send'
require 'mutest/ast/meta/const'
require 'mutest/ast/meta/symbol'
require 'mutest/ast/meta/optarg'
require 'mutest/ast/meta/resbody'
require 'mutest/ast/meta/restarg'
require 'mutest/actor'
require 'mutest/actor/receiver'
require 'mutest/actor/sender'
require 'mutest/actor/mailbox'
require 'mutest/actor/env'
require 'mutest/parser'
require 'mutest/source_file'
require 'mutest/isolation'
require 'mutest/isolation/none'
require 'mutest/isolation/fork'
require 'mutest/parallel'
require 'mutest/parallel/master'
require 'mutest/parallel/worker'
require 'mutest/parallel/source'
require 'mutest/warning_filter'
require 'mutest/require_highjack'
require 'mutest/mutation'
require 'mutest/mutator'
require 'mutest/mutator/util'
require 'mutest/mutator/util/array'
require 'mutest/mutator/util/symbol'
require 'mutest/mutator/node'
require 'mutest/mutator/node/generic'
require 'mutest/mutator/node/regexp'
require 'mutest/mutator/node/regexp/alternation_meta'
require 'mutest/mutator/node/regexp/capture_group'
require 'mutest/mutator/node/regexp/character_type'
require 'mutest/mutator/node/regexp/end_of_line_anchor'
require 'mutest/mutator/node/regexp/end_of_string_or_before_end_of_line_anchor'
require 'mutest/mutator/node/regexp/one_or_more'
require 'mutest/mutator/node/regexp/zero_or_more'
require 'mutest/mutator/node/literal'
require 'mutest/mutator/node/literal/boolean'
require 'mutest/mutator/node/literal/range'
require 'mutest/mutator/node/literal/symbol'
require 'mutest/mutator/node/literal/string'
require 'mutest/mutator/node/literal/fixnum'
require 'mutest/mutator/node/literal/float'
require 'mutest/mutator/node/literal/array'
require 'mutest/mutator/node/literal/hash'
require 'mutest/mutator/node/literal/regex'
require 'mutest/mutator/node/literal/nil'
require 'mutest/mutator/node/argument'
require 'mutest/mutator/node/arguments'
require 'mutest/mutator/node/begin'
require 'mutest/mutator/node/binary'
require 'mutest/mutator/node/const'
require 'mutest/mutator/node/dstr'
require 'mutest/mutator/node/dsym'
require 'mutest/mutator/node/kwbegin'
require 'mutest/mutator/node/named_value/access'
require 'mutest/mutator/node/named_value/constant_assignment'
require 'mutest/mutator/node/named_value/variable_assignment'
require 'mutest/mutator/node/next'
require 'mutest/mutator/node/break'
require 'mutest/mutator/node/block_pass'
require 'mutest/mutator/node/or_asgn'
require 'mutest/mutator/node/and_asgn'
require 'mutest/mutator/node/defined'
require 'mutest/mutator/node/op_asgn'
require 'mutest/mutator/node/conditional_loop'
require 'mutest/mutator/node/yield'
require 'mutest/mutator/node/super'
require 'mutest/mutator/node/zsuper'
require 'mutest/mutator/node/send'
require 'mutest/mutator/node/send/binary'
require 'mutest/mutator/node/send/conditional'
require 'mutest/mutator/node/send/attribute_assignment'
require 'mutest/mutator/node/send/index'
require 'mutest/mutator/node/when'
require 'mutest/mutator/node/class'
require 'mutest/mutator/node/define'
require 'mutest/mutator/node/mlhs'
require 'mutest/mutator/node/nthref'
require 'mutest/mutator/node/masgn'
require 'mutest/mutator/node/return'
require 'mutest/mutator/node/block'
require 'mutest/mutator/node/if'
require 'mutest/mutator/node/case'
require 'mutest/mutator/node/splat'
require 'mutest/mutator/node/regopt'
require 'mutest/mutator/node/resbody'
require 'mutest/mutator/node/rescue'
require 'mutest/mutator/node/match_current_line'
require 'mutest/loader'
require 'mutest/context'
require 'mutest/scope'
require 'mutest/subject'
require 'mutest/subject/method'
require 'mutest/subject/method/instance'
require 'mutest/subject/method/singleton'
require 'mutest/matcher'
require 'mutest/matcher/config'
require 'mutest/matcher/compiler'
require 'mutest/matcher/chain'
require 'mutest/matcher/method'
require 'mutest/matcher/method/singleton'
require 'mutest/matcher/method/instance'
require 'mutest/matcher/methods'
require 'mutest/matcher/namespace'
require 'mutest/matcher/scope'
require 'mutest/matcher/filter'
require 'mutest/matcher/null'
require 'mutest/matcher/static'
require 'mutest/expression'
require 'mutest/expression/parser'
require 'mutest/expression/method'
require 'mutest/expression/methods'
require 'mutest/expression/namespace'
require 'mutest/test'
require 'mutest/integration'
require 'mutest/integration/null'
require 'mutest/selector'
require 'mutest/selector/expression'
require 'mutest/config'
require 'mutest/cli'
require 'mutest/color'
require 'mutest/diff'
require 'mutest/runner'
require 'mutest/runner/sink'
require 'mutest/result'
require 'mutest/reporter'
require 'mutest/reporter/null'
require 'mutest/reporter/sequence'
require 'mutest/reporter/cli'
require 'mutest/reporter/cli/printer'
require 'mutest/reporter/cli/printer/config'
require 'mutest/reporter/cli/printer/env_result'
require 'mutest/reporter/cli/printer/env_progress'
require 'mutest/reporter/cli/printer/mutation_result'
require 'mutest/reporter/cli/printer/mutation_progress_result'
require 'mutest/reporter/cli/printer/subject_progress'
require 'mutest/reporter/cli/printer/subject_result'
require 'mutest/reporter/cli/printer/status'
require 'mutest/reporter/cli/printer/status_progressive'
require 'mutest/reporter/cli/printer/test_result'
require 'mutest/reporter/cli/tput'
require 'mutest/reporter/cli/format'
require 'mutest/repository'
require 'mutest/requirer'
require 'mutest/zombifier'

module Mutest
  # Reopen class to initialize constant to avoid dep circle
  class Config
    DEFAULT = new(
      expression_parser: Expression::Parser.new([
        Expression::Method,
        Expression::Methods,
        Expression::Namespace::Exact,
        Expression::Namespace::Recursive
      ]),
      fail_fast:         false,
      includes:          EMPTY_ARRAY,
      integration:       Integration::Null,
      isolation:         Mutest::Isolation::Fork.new(
        devnull: ->(&block) { File.open(File::NULL, File::WRONLY, &block) },
        stdout:  $stdout,
        stderr:  $stderr,
        io:      IO,
        marshal: Marshal,
        process: Process
      ),
      jobs:              ::Parallel.processor_count,
      requirer:          Requirer.new,
      kernel:            Kernel,
      load_path:         $LOAD_PATH,
      matcher:           Matcher::Config::DEFAULT,
      open3:             Open3,
      pathname:          Pathname,
      requires:          EMPTY_ARRAY,
      reporter:          Reporter::CLI.build($stdout),
      zombie:            false
    )
  end # Config
end # Mutest
