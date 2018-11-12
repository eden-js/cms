<page-admin-remove-page>
  <div class="page page-admin px-3 px-md-4 py-gutter">
    <div class="row">
      <div class="col-md-8 col-lg-6">
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
  </div>
</page-admin-remove-page>
