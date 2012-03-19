# encoding: utf-8
require 'spec_helper'
require 'helpers/postgresql_spec_helper'

describe "Postgresql: " do
  let(:ski) { Skiima.new(:postgresql_test) }
  
  describe "Connection Setup: " do
    it "should get the version" do
      ensure_closed(ski) do |s|
        s.connection.version.must_be_instance_of Fixnum
      end
    end

    it "should get the timestamp" do
      ensure_closed(ski) do |s|
        s.connection.local_tz.must_be_instance_of String
      end
    end
  end

  describe "Create/Drop Databases: " do
    
  end

  describe "Create/Drop Table: " do
    it "should be able to create and drop a table" do
      ensure_closed(ski) do |skiima|
        within_transaction(skiima) do |s|
          s.connection.table_exists?('test_table').must_equal false
          s.up(:test_table)
          s.connection.table_exists?('test_table').must_equal true
          s.down(:test_table)
          s.connection.table_exists?('test_table').must_equal false
        end
      end
    end

    it "should handle multiple schemas in a database" do

    end
  end

  describe "Create/Drop Schema: " do
    #schema's cant be rolled back
    it "should be able to create and drop schemas" do
      ensure_closed(ski) do |s|
        s.connection.schema_exists?('test_schema').must_equal false
        s.up(:test_schema)
        s.connection.schema_exists?('test_schema').must_equal true
        s.down(:test_schema)
        s.connection.schema_exists?('test_schema').must_equal false
      end
    end
  end

  describe "Create/Drop View: " do
    it "should be able to create and drop views" do
      ensure_closed(ski) do |skiima|
        within_transaction(skiima) do |s|
          s.connection.table_exists?('test_table').must_equal false
          s.connection.view_exists?('test_view').must_equal false

          s.up(:test_table, :test_view)
          s.connection.table_exists?('test_table').must_equal true
          s.connection.view_exists?('test_view').must_equal true

          s.down(:test_table, :test_view)
          s.connection.table_exists?('test_table').must_equal false
          s.connection.view_exists?('test_view').must_equal false
        end
      end
    end
  end

  describe "Create/Drop Rules: " do
    it "should be able to create and drop rules" do
      ensure_closed(ski) do |skiima|
        within_transaction(skiima) do |s|
          s.connection.table_exists?('test_table').must_equal false
          s.connection.view_exists?('test_view').must_equal false
          s.connection.rule_exists?('test_rule', :attr => ['test_view']).must_equal false

          s.up(:test_table, :test_view, :test_rule)
          s.connection.table_exists?('test_table').must_equal true
          s.connection.view_exists?('test_view').must_equal true
          s.connection.rule_exists?('test_rule', :attr => ['test_view']).must_equal true

          s.down(:test_table, :test_view, :test_rule)
          s.connection.table_exists?('test_table').must_equal false
          s.connection.view_exists?('test_view').must_equal false
          s.connection.rule_exists?('test_rule', :attr => ['test_view']).must_equal false
        end
      end
    end
  end

  describe "Create/Drop Indexes: " do
    it "should be able to create and drop indexes" do
      ensure_closed(ski) do |skiima|
        within_transaction(skiima) do |s|
          s.connection.table_exists?('test_table').must_equal false
          s.connection.index_exists?('test_index', :attr => ['test_table']).must_equal false

          s.up(:test_table, :test_index)
          s.connection.table_exists?('test_table').must_equal true
          s.connection.index_exists?('test_index', :attr => ['test_table']).must_equal true

          s.down(:test_table, :test_index)
          s.connection.table_exists?('test_table').must_equal false
          s.connection.index_exists?('test_index', :attr => ['test_table']).must_equal false
        end
      end
    end
  end
end
