<page-admin-remove-page>
  <div class="page page-admin">
  
    <admin-header title="Remove Page">
      <yield to="right">
        <a href="/admin/banner" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <form method="post" action="/admin/page/{ opts.item.id }/remove">
        <div class="card">
          <div class="card-body">
            <p>
              Are you sure you want to delete <b>{ opts.item.title }</b>?
            </p>
          </div>
          <div class="card-block text-right">
            <button type="submit" class="btn btn-success btn-card btn-lg">Remove Page</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</page-admin-remove-page>
