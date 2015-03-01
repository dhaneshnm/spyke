require 'test_helper'

module Spyke
  class CustomRequestTest < MiniTest::Test
    def test_custom_get_request_using_class_method
      endpoint = stub_request(:get, 'http://sushi.com/recipes/recent').to_return_json(result: [{ id: 1, title: 'Bread' }])
      recipes = Recipe.with_uri('/recipes/recent').get
      assert_equal %w{ Bread }, recipes.map(&:title)
      assert_requested endpoint
    end

    def test_get_request_with_prepended_scope
      endpoint = stub_request(:get, 'http://sushi.com/recipes/recent?status=published')
      Recipe.published.with_uri('/recipes/recent').to_a
      assert_requested endpoint
    end

    def test_get_request_with_appended_scope
      endpoint = stub_request(:get, 'http://sushi.com/recipes/recent?status=published')
      Recipe.with_uri('/recipes/recent').published.to_a
      assert_requested endpoint
    end

    def test_get_request_with_appended_scope_symbol
      endpoint = stub_request(:get, 'http://sushi.com/recipes/recent?status=published')
      Recipe.with_uri(:recent).published.to_a
      assert_requested endpoint
    end

    def test_create_on_custom_uri
      endpoint = stub_request(:post, 'http://sushi.com/recipes/recent').with(body: { recipe: { status: 'published' } })
      Recipe.with_uri(:recent).published.create
      assert_requested endpoint
    end

    def test_custom_get_request_from_class
      endpoint = stub_request(:get, 'http://sushi.com/recipes/recent').to_return_json(result: [{ id: 1, title: 'Bread' }])
      assert_equal %w{ Bread }, Recipe.with_uri('/recipes/recent').get.map(&:title)
      assert_requested endpoint
    end

    def test_custom_put_request_from_class
      endpoint = stub_request(:put, 'http://sushi.com/recipes/1/publish')
      Recipe.with_uri('/recipes/1/publish').put
      assert_requested endpoint
    end

    def test_custom_put_request_from_instance
      endpoint = stub_request(:put, 'http://sushi.com/recipes/1/publish').to_return_json(result: { id: 1, status: 'published' })
      recipe = Recipe.new(id: 1, status: 'unpublished')
      recipe.put('/recipes/:id/publish')

      assert_equal 'published', recipe.status
      assert_requested endpoint
    end

    def test_custom_put_request_from_instance_with_symbol
      endpoint = stub_request(:put, 'http://sushi.com/recipes/1/draft')
      recipe = Recipe.new(id: 1)
      recipe.put(:draft)
      assert_requested endpoint
    end
  end
end
