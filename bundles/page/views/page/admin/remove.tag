<page-admin-remove-page>
  <div class="page page-admin">
  
    <admin-header title="Remove Page">
      <yield to="right">
        <a href="/admin/page" class="btn btn-lg btn-primary">
          Back
        </a>
      </yield>
    </admin-header>
    
    <div class="container-fluid">
    
      <form method="post" action="/admin/page/{ opts.item.id }/remove">
        <div class="card">
          <div class="card-body">
            <p class="m-0">
              Are you sure you want remove this page?
            </p>
          </div>
          <div class="card-footer text-right">
            <button type="submit" class="btn btn-danger btn-card">Remove Page</button>
          </div>
        </div>
      </form>

    </div>
  </div>
</page-admin-remove-page>
