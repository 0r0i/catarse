class AddDeleteProjectsEndpoint < ActiveRecord::Migration
  def change
    execute <<-SQL
      CREATE OR REPLACE FUNCTION "1".delete_project(_project_id integer) RETURNS void
          LANGUAGE plpgsql
          AS $$
            declare
                v_project public.projects;
            begin
                select * from public.projects where id = _project_id into v_project;

                if _project_id is null or not public.is_owner_or_admin(v_project.user_id) or v_project.state <> 'draft' then
                    raise exception 'invalid project permission';
                end if;

                update project_transitions pt set most_recent = false where pt.project_id = _project_id;
                insert into public.project_transitions (to_state, metadata, sort_key, project_id, most_recent, created_at, updated_at) 
                values ('deleted', '{"to_state":"deleted", "from_state":' || (select p.state from projects p where id = _project_id) || '}', 0, _project_id, true, current_timestamp, current_timestamp);
                update projects set state = 'deleted' where id = _project_id;
              end;
            $$;

      grant execute on function "1".delete_project(integer) to admin, web_user;

      grant insert, select, update on public.project_transitions to admin;
      grant insert, select, update on public.project_transitions to web_user;
      grant update on public.projects to admin;
      grant update on public.projects to web_user;
    SQL
  end
end
