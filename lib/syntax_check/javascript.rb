
module Redcar
  module SyntaxCheck
    class JavaScript < Checker
      supported_grammars  "JavaScript", "HTML"

      def lint
        File.join(File.dirname(__FILE__),'..','..','vendor','jshint-rhino.js')
      end

      def rhino
        File.join(File.expand_path('../../../vendor/rhino1_7R3.jar', __FILE__))
      end

      def main_method
        "org.mozilla.javascript.tools.shell.Main"
      end

      def check(*args)
        path = manifest_path(doc)
        name = File.basename(path)
        if t = JavaScript.thread and t.alive?
          if t[:doc] and t[:doc] == doc
            t.exit
            SyntaxCheck.remove_syntax_error_annotations(doc.edit_view)
          end
        end
        JavaScript.thread=Thread.new do
          SyntaxCheck.remove_syntax_error_annotations(doc.edit_view)
          Thread.current[:doc] = doc
          begin
            output = `java -cp #{rhino} #{main_method} #{jshint} #{path}`
            output.each_line do |line|
              if line =~ /Lint at line (\d+) character (\d+): (.*)/
                SyntaxCheck::Error.new(doc, $1.to_i-1, $3).annotate
                sleep 1
              end
            end
          rescue Object => e
            SyntaxCheck.message(
            "An error occurred while parsing #{name}: #{e.message}",:error)
          end
        end
      end

      private

      def self.thread=(thread)
        @thread=thread
      end

      def self.thread
        @thread
      end
    end
  end
end
