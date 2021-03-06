module Polytrix
  module Util
    describe FileSystem do
      subject(:finder) do
        Object.new.extend(Polytrix::Util::FileSystem)
      end

      it 'finds files within the search path' do
        search_path = 'spec/fixtures/src-doc'
        file = finder.find_file search_path, 'quine'
        expect(file.relative_path_from path(search_path)).to eq(path('quine.md.erb'))
      end

      it 'raises Errno::ENOENT if no file is found' do
        expect { finder.find_file 'spec/fixtures/src-doc', 'quinez' }.to raise_error Errno::ENOENT
      end

      private

      def path(p)
        Pathname.new p
      end
    end
  end
end
