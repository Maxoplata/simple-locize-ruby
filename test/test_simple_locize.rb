require 'dotenv/load'
require 'minitest/autorun'
require 'simple_locize'

class SimpleLocizeTest < Minitest::Test
    def setup
        @namespace = ENV['LOCIZE_NAMESPACE']

        @locize_public = SimpleLocize.new(ENV['LOCIZE_PROJECT_ID'], ENV['LOCIZE_ENVIRONMENT'])
        @locize_private = SimpleLocize.new(ENV['LOCIZE_PROJECT_ID'], ENV['LOCIZE_PRIVATE_ENVIRONMENT'], ENV['LOCIZE_PRIVATE_KEY'])
    end

    def test_get_all_translations_from_namespace_public
        test_en = @locize_public.get_all_translations_from_namespace(@namespace, 'en')
		test_es = @locize_public.get_all_translations_from_namespace(@namespace, 'es')

        assert_equal 'One', test_en['one']
        assert_equal 'Uno', test_es['one']
        assert_equal 'Two Three', test_en['two']['three']
        assert_equal 'Dos Tres', test_es['two']['three']
        assert_equal 'Four Five Six', test_en['four']['five']['six']
        assert_equal 'Quattro Cinco Seis', test_es['four']['five']['six']
    end

    def test_translate_public
        test1 = @locize_public.translate(@namespace, 'en', 'one')
        test2 = @locize_public.translate(@namespace, 'es', 'one')
        test3 = @locize_public.translate(@namespace, 'en', 'two.three')
        test4 = @locize_public.translate(@namespace, 'es', 'two.three')
        test5 = @locize_public.translate(@namespace, 'en', 'four.five.six')
        test6 = @locize_public.translate(@namespace, 'es', 'four.five.six')

        assert_equal 'One', test1
        assert_equal 'Uno', test2
        assert_equal 'Two Three', test3
        assert_equal 'Dos Tres', test4
        assert_equal 'Four Five Six', test5
        assert_equal 'Quattro Cinco Seis', test6
    end

    def test_get_all_translations_from_namespace_private
        test_en = @locize_private.get_all_translations_from_namespace(@namespace, 'en')
		test_es = @locize_private.get_all_translations_from_namespace(@namespace, 'es')

        assert_equal 'One', test_en['one']
        assert_equal 'Uno', test_es['one']
        assert_equal 'Two Three', test_en['two']['three']
        assert_equal 'Dos Tres', test_es['two']['three']
        assert_equal 'Four Five Six', test_en['four']['five']['six']
        assert_equal 'Quattro Cinco Seis', test_es['four']['five']['six']
    end

    def test_translate_private
        test1 = @locize_private.translate(@namespace, 'en', 'one')
        test2 = @locize_private.translate(@namespace, 'es', 'one')
        test3 = @locize_private.translate(@namespace, 'en', 'two.three')
        test4 = @locize_private.translate(@namespace, 'es', 'two.three')
        test5 = @locize_private.translate(@namespace, 'en', 'four.five.six')
        test6 = @locize_private.translate(@namespace, 'es', 'four.five.six')

        assert_equal 'One', test1
        assert_equal 'Uno', test2
        assert_equal 'Two Three', test3
        assert_equal 'Dos Tres', test4
        assert_equal 'Four Five Six', test5
        assert_equal 'Quattro Cinco Seis', test6
    end
end
