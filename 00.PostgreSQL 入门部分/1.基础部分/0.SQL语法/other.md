方法3:perform替代了select,表示不要数据。
    perform relname from pg_class where relname = p_table_name;
    if found then
        return true;
    end if;
